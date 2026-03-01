using EchoesOfChoice.CharacterClasses.Abilities.Enemy;
using EchoesOfChoice.CharacterClasses.Common;
using System.Collections.Generic;

namespace EchoesOfChoice.CharacterClasses.Enemies
{
    public class Ironclad : BaseFighter
    {
        public Ironclad(int level = 6)
        {
            Level = level;
            Health = Stat(87, 97, 0, 0, 6);
            MaxHealth = Health;
            PhysicalAttack = Stat(23, 27, 0, 0, 6);
            PhysicalDefense = Stat(26, 30, 0, 0, 6);
            MagicAttack = Stat(15, 19, 0, 0, 6);
            MagicDefense = Stat(25, 29, 0, 0, 6);
            Speed = Stat(24, 29, 0, 0, 6);
            Abilities = new List<Ability>() { new HammerBlow(), new Temper(), new SteelPlating() };
            CharacterType = "Ironclad";
            Mana = Stat(21, 26, 0, 0, 6);
            MaxMana = Mana;
            CritChance = 10;
            CritDamage = 1;
            DodgeChance = 10;
        }

        public Ironclad(BaseFighter fighter) : base(fighter) { }

        public override BaseFighter Clone()
        {
            return new Ironclad(this);
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
