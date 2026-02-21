using EchoesOfChoice.CharacterClasses.Abilities;
using EchoesOfChoice.CharacterClasses.Abilities.Enemy;
using EchoesOfChoice.CharacterClasses.Common;
using System.Collections.Generic;

namespace EchoesOfChoice.CharacterClasses.Enemies
{
    public class Thug : BaseFighter
    {
        public Thug(int level = 1)
        {
            Level = level;
            Health = Stat(42, 52, 3, 7);
            MaxHealth = Health;
            PhysicalAttack = Stat(13, 17, 1, 3);
            PhysicalDefense = Stat(8, 12, 1, 2);
            MagicAttack = Stat(3, 6, 0, 2);
            MagicDefense = Stat(8, 12, 1, 2);
            Speed = Stat(12, 16, 1, 3);
            Abilities = new List<Ability>() { new Haymaker() };
            CharacterType = "Thug";
            Mana = Stat(4, 8, 1, 3);
            MaxMana = Mana;
            CritChance = 1;
            CritDamage = 1;
            DodgeChance = 1;
        }

        public Thug(BaseFighter fighter) : base(fighter) { }

        public override BaseFighter Clone()
        {
            return new Thug(this);
        }

        public override void IncreaseLevel()
        {
            Level += 1;
            var healthIncrease = random.Next(3, 7);
            Health += healthIncrease;
            MaxHealth += healthIncrease;
            var manaIncrease = random.Next(1, 3);
            Mana += manaIncrease;
            MaxMana += manaIncrease;
            PhysicalAttack += random.Next(1, 3);
            PhysicalDefense += random.Next(1, 2);
            MagicAttack += random.Next(0, 2);
            MagicDefense += random.Next(1, 2);
            Speed += random.Next(1, 3);
        }

        public override BaseFighter UpgradeClass(UpgradeItemEnum upgradeItem)
        {
            throw new System.NotImplementedException();
        }
    }
}
