using EchoesOfChoice.CharacterClasses.Common;

namespace EchoesOfChoice.CharacterClasses.Abilities
{
    class TimeWarp : Ability
    {
        public TimeWarp()
        {
            Name = "Time Warp";
            FlavorText = "Bend the flow of time around an ally, accelerating their every move. Increases speed.";
            ModifiedStat = StatEnum.Speed;
            Modifier = 5;
            impactedTurns = 2;
            UseOnEnemy = false;
            ManaCost = 2;
        }
    }
}
