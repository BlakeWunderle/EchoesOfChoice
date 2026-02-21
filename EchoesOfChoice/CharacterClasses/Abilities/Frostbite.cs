using EchoesOfChoice.CharacterClasses.Common;

namespace EchoesOfChoice.CharacterClasses.Abilities
{
    class Frostbite : Ability
    {
        public Frostbite()
        {
            Name = "Frostbite";
            FlavorText = "Should have stayed warmer. Decreases speed.";
            ModifiedStat = StatEnum.Speed;
            Modifier = 5;
            impactedTurns = 2;
            UseOnEnemy = true;
            ManaCost = 2;
        }
    }
}
