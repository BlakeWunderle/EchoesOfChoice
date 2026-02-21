using EchoesOfChoice.CharacterClasses.Abilities.Enemy;
using EchoesOfChoice.CharacterClasses.Common;
using System.Collections.Generic;

namespace EchoesOfChoice.CharacterClasses.Enemies
{
    public class Demon : BaseFighter
    {
        public Demon(int level = 6)
        {
            Level = level;
            Health = Stat(255, 265, 0, 0, 6);
            MaxHealth = Health;
            PhysicalAttack = Stat(17, 21, 0, 0, 6);
            PhysicalDefense = Stat(17, 21, 0, 0, 6);
            MagicAttack = Stat(40, 44, 0, 0, 6);
            MagicDefense = Stat(22, 26, 0, 0, 6);
            Speed = Stat(13, 17, 0, 0, 6);
            Abilities = new List<Ability>() { new Brimstone(), new InfernalStrike(), new Dread() };
            CharacterType = "Demon";
            Mana = Stat(38, 42, 0, 0, 6);
            MaxMana = Mana;
            CritChance = 2;
            CritDamage = 2;
            DodgeChance = 3;
        }

        public Demon(BaseFighter fighter) : base(fighter) { }

        public override BaseFighter Clone()
        {
            return new Demon(this);
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
