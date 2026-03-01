using EchoesOfChoice.CharacterClasses.Abilities;
using EchoesOfChoice.CharacterClasses.Abilities.Enemy;
using EchoesOfChoice.CharacterClasses.Common;
using System.Collections.Generic;

namespace EchoesOfChoice.CharacterClasses.Enemies
{
    public class Commander : BaseFighter
    {
        public Commander(int level = 6)
        {
            Level = level;
            Health = Stat(98, 110, 0, 0, 6);
            MaxHealth = Health;
            PhysicalAttack = Stat(25, 29, 0, 0, 6);
            PhysicalDefense = Stat(26, 30, 0, 0, 6);
            MagicAttack = Stat(11, 15, 0, 0, 6);
            MagicDefense = Stat(22, 27, 0, 0, 6);
            Speed = Stat(28, 33, 0, 0, 6);
            Abilities = new List<Ability>() { new ShieldWall(), new RallyStrike(), new WarWard() };
            CharacterType = "Commander";
            Mana = Stat(22, 26, 0, 0, 6);
            MaxMana = Mana;
            CritChance = 20;
            CritDamage = 2;
            DodgeChance = 10;
        }

        public Commander(BaseFighter fighter) : base(fighter) { }

        public override BaseFighter Clone()
        {
            return new Commander(this);
        }

        public override void IncreaseLevel()
        {
            Level += 1;
            var healthIncrease = random.Next(0, 1);
            Health += healthIncrease;
            MaxHealth += healthIncrease;
            var manaIncrease = random.Next(0, 1);
            Mana += manaIncrease;
            MaxMana += manaIncrease;
            PhysicalAttack += random.Next(0, 1);
            PhysicalDefense += random.Next(0, 1);
            MagicAttack += random.Next(0, 1);
            MagicDefense += random.Next(0, 1);
            Speed += random.Next(0, 1);
        }

        public override BaseFighter UpgradeClass(UpgradeItemEnum upgradeItem)
        {
            throw new System.NotImplementedException();
        }
    }
}
