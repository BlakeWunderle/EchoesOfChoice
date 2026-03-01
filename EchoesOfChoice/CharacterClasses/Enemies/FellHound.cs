using EchoesOfChoice.CharacterClasses.Abilities.Enemy;
using EchoesOfChoice.CharacterClasses.Common;
using System.Collections.Generic;

namespace EchoesOfChoice.CharacterClasses.Enemies
{
    public class FellHound : BaseFighter
    {
        public FellHound(int level = 16)
        {
            Level = level;
            Health = Stat(240, 270, 7, 10, 16);
            MaxHealth = Health;
            PhysicalAttack = Stat(20, 26, 1, 2, 16);
            PhysicalDefense = Stat(22, 28, 1, 3, 16);
            MagicAttack = Stat(42, 50, 3, 5, 16);
            MagicDefense = Stat(28, 34, 2, 3, 16);
            Speed = Stat(36, 42, 3, 4, 16);
            Abilities = new List<Ability>() { new ShadowBite(), new HowlOfDread(), new Blight() };
            CharacterType = "Fell Hound";
            Mana = Stat(24, 30, 2, 4, 16);
            MaxMana = Mana;
            CritChance = 20;
            CritDamage = 4;
            DodgeChance = 22;
        }

        public FellHound(BaseFighter fighter) : base(fighter) { }

        public override BaseFighter Clone()
        {
            return new FellHound(this);
        }

        public override void IncreaseLevel()
        {
            Level += 1;
            var healthIncrease = random.Next(5, 8);
            Health += healthIncrease;
            MaxHealth += healthIncrease;
            var manaIncrease = random.Next(2, 4);
            Mana += manaIncrease;
            MaxMana += manaIncrease;
            PhysicalAttack += random.Next(1, 2);
            PhysicalDefense += random.Next(1, 2);
            MagicAttack += random.Next(2, 4);
            MagicDefense += random.Next(1, 3);
            Speed += random.Next(2, 3);
        }

        public override BaseFighter UpgradeClass(UpgradeItemEnum upgradeItem)
        {
            throw new System.NotImplementedException();
        }
    }
}
